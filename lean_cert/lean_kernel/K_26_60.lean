import Sound
import lean_certs.cert_26_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_60_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 26) (d := 60) (c := cert_26_60) (by decide)
