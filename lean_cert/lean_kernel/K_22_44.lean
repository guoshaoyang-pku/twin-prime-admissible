import Sound
import lean_certs.cert_22_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_44_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 22) (d := 44) (c := cert_22_44) (by decide)
