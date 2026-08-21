import Sound
import lean_certs.cert_49_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_168_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 49) (d := 168) (c := cert_49_168) (by decide)
