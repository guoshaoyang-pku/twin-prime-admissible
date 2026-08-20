import Sound
import lean_certs.cert_32_102

open CertVerify

theorem H32_gt_102 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 32) (d := 102) (c := cert_32_102) (by native_decide)
