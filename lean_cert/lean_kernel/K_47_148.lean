import Sound
import lean_certs.cert_47_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_148_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 47) (d := 148) (c := cert_47_148) (by decide)
