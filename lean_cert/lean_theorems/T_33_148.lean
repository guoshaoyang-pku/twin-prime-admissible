import Sound
import lean_certs.cert_33_148

open CertVerify

theorem H33_gt_148 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 33) (d := 148) (c := cert_33_148) (by native_decide)
