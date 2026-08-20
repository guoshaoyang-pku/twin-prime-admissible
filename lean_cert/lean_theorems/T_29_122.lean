import Sound
import lean_certs.cert_29_122

open CertVerify

theorem H29_gt_122 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 29) (d := 122) (c := cert_29_122) (by native_decide)
