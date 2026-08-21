import Sound
import lean_certs.cert_38_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_128_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 38) (d := 128) (c := cert_38_128) (by decide)
