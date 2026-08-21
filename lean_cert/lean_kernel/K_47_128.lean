import Sound
import lean_certs.cert_47_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_128_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 47) (d := 128) (c := cert_47_128) (by decide)
