import Sound
import lean_certs.cert_18_58

open CertVerify

theorem H18_gt_58 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 18) (d := 58) (c := cert_18_58) (by native_decide)
