import Sound
import lean_certs.cert_46_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_128_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 46) (d := 128) (c := cert_46_128) (by decide)
