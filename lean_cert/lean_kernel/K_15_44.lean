import Sound
import lean_certs.cert_15_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_44_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 15) (d := 44) (c := cert_15_44) (by decide)
