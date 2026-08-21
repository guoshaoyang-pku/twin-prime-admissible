import Sound
import lean_certs.cert_35_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_128_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 35) (d := 128) (c := cert_35_128) (by decide)
