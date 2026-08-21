import Sound
import lean_certs.cert_36_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_128_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 36) (d := 128) (c := cert_36_128) (by decide)
