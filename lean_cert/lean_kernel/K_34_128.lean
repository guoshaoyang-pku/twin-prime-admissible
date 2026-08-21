import Sound
import lean_certs.cert_34_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_128_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 34) (d := 128) (c := cert_34_128) (by decide)
