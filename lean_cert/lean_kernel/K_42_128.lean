import Sound
import lean_certs.cert_42_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_128_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 42) (d := 128) (c := cert_42_128) (by decide)
