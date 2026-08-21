import Sound
import lean_certs.cert_14_36

open CertVerify

theorem H14_gt_36 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 14) (d := 36) (c := cert_14_36) (by native_decide)
