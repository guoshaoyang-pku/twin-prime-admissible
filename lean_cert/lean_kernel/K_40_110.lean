import Sound
import lean_certs.cert_40_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_110_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 40) (d := 110) (c := cert_40_110) (by decide)
