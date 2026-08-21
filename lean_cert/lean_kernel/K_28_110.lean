import Sound
import lean_certs.cert_28_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_110_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 28) (d := 110) (c := cert_28_110) (by decide)
