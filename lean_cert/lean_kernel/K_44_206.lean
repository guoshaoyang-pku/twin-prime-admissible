import Sound
import lean_certs.cert_44_206

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_206_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 44) (d := 206) (c := cert_44_206) (by decide)
