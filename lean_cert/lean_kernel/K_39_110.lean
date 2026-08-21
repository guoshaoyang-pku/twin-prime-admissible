import Sound
import lean_certs.cert_39_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_110_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 39) (d := 110) (c := cert_39_110) (by decide)
