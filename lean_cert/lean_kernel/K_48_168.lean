import Sound
import lean_certs.cert_48_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_168_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 48) (d := 168) (c := cert_48_168) (by decide)
