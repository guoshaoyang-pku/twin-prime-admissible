import Sound
import lean_certs.cert_32_72

open CertVerify

theorem H32_gt_72 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 32) (d := 72) (c := cert_32_72) (by native_decide)
