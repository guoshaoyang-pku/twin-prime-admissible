import Sound
import lean_certs.cert_44_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_160_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 44) (d := 160) (c := cert_44_160) (by decide)
