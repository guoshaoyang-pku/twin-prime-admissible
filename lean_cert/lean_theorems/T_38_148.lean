import Sound
import lean_certs.cert_38_148

open CertVerify

theorem H38_gt_148 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 38) (d := 148) (c := cert_38_148) (by native_decide)
