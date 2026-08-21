import Sound
import lean_certs.cert_50_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_110_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 50) (d := 110) (c := cert_50_110) (by decide)
