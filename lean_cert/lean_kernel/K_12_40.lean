import Sound
import lean_certs.cert_12_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_40_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 12) (d := 40) (c := cert_12_40) (by decide)
