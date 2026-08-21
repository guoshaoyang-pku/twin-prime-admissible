import Sound
import lean_certs.cert_30_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_128_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 30) (d := 128) (c := cert_30_128) (by decide)
