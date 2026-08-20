import Sound
import lean_certs.cert_28_102

open CertVerify

theorem H28_gt_102 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 28) (d := 102) (c := cert_28_102) (by native_decide)
