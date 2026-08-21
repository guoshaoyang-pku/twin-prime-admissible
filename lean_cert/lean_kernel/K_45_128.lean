import Sound
import lean_certs.cert_45_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_128_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 45) (d := 128) (c := cert_45_128) (by decide)
