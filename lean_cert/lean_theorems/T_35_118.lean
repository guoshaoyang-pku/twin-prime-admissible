import Sound
import lean_certs.cert_35_118

open CertVerify

theorem H35_gt_118 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 35) (d := 118) (c := cert_35_118) (by native_decide)
