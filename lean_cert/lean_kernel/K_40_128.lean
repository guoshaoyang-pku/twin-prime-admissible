import Sound
import lean_certs.cert_40_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_128_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 40) (d := 128) (c := cert_40_128) (by decide)
