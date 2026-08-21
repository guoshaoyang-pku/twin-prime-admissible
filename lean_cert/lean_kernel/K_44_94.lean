import Sound
import lean_certs.cert_44_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_94_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 44) (d := 94) (c := cert_44_94) (by decide)
