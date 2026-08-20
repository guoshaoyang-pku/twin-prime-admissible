import Sound
import lean_certs.cert_32_82

open CertVerify

theorem H32_gt_82 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 32) (d := 82) (c := cert_32_82) (by native_decide)
