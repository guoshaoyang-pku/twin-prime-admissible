import Sound
import lean_certs.cert_37_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_120_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 37) (d := 120) (c := cert_37_120) (by decide)
