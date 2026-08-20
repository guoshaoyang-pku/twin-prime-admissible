import Sound
import lean_certs.cert_35_96

open CertVerify

theorem H35_gt_96 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 35) (d := 96) (c := cert_35_96) (by native_decide)
