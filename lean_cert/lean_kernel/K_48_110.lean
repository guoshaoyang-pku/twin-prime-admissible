import Sound
import lean_certs.cert_48_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_110_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 48) (d := 110) (c := cert_48_110) (by decide)
