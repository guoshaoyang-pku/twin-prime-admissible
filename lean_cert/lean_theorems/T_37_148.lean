import Sound
import lean_certs.cert_37_148

open CertVerify

theorem H37_gt_148 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 37) (d := 148) (c := cert_37_148) (by native_decide)
