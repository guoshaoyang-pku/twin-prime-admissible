import Sound
import lean_certs.cert_36_148

open CertVerify

theorem H36_gt_148 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 36) (d := 148) (c := cert_36_148) (by native_decide)
