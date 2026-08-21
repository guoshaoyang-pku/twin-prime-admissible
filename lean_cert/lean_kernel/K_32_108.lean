import Sound
import lean_certs.cert_32_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_108_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 32) (d := 108) (c := cert_32_108) (by decide)
