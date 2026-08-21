import Sound
import lean_certs.cert_44_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_110_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 44) (d := 110) (c := cert_44_110) (by decide)
