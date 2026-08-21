import Sound
import lean_certs.cert_17_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_44_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 17) (d := 44) (c := cert_17_44) (by decide)
