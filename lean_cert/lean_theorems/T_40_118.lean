import Sound
import lean_certs.cert_40_118

open CertVerify

theorem H40_gt_118 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 40) (d := 118) (c := cert_40_118) (by native_decide)
