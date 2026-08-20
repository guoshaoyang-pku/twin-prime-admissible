import Sound
import lean_certs.cert_48_148

open CertVerify

theorem H48_gt_148 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 48) (d := 148) (c := cert_48_148) (by native_decide)
