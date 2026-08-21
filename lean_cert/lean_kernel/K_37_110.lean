import Sound
import lean_certs.cert_37_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_110_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 37) (d := 110) (c := cert_37_110) (by decide)
