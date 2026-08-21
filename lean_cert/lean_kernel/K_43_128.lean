import Sound
import lean_certs.cert_43_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_128_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 43) (d := 128) (c := cert_43_128) (by decide)
