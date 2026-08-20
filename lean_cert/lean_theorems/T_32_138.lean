import Sound
import lean_certs.cert_32_138

open CertVerify

theorem H32_gt_138 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 32) (d := 138) (c := cert_32_138) (by native_decide)
