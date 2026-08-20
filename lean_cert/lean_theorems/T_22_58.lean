import Sound
import lean_certs.cert_22_58

open CertVerify

theorem H22_gt_58 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 22) (d := 58) (c := cert_22_58) (by native_decide)
