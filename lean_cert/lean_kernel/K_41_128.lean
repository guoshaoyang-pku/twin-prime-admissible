import Sound
import lean_certs.cert_41_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_128_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 41) (d := 128) (c := cert_41_128) (by decide)
