import Sound
import lean_certs.cert_32_64

open CertVerify

theorem H32_gt_64 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 32) (d := 64) (c := cert_32_64) (by native_decide)
