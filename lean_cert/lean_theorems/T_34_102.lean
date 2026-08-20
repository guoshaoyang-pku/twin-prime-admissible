import Sound
import lean_certs.cert_34_102

open CertVerify

theorem H34_gt_102 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 34) (d := 102) (c := cert_34_102) (by native_decide)
