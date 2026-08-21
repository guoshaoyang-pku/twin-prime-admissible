import Sound
import lean_certs.cert_50_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_128_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 50) (d := 128) (c := cert_50_128) (by decide)
