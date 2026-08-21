import Sound
import lean_certs.cert_18_36

open CertVerify

theorem H18_gt_36 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 18) (d := 36) (c := cert_18_36) (by native_decide)
