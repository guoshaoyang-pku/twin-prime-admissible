import Sound
import lean_certs.cert_39_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_128_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 39) (d := 128) (c := cert_39_128) (by decide)
