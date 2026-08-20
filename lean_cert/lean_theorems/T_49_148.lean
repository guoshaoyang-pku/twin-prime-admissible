import Sound
import lean_certs.cert_49_148

open CertVerify

theorem H49_gt_148 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 49) (d := 148) (c := cert_49_148) (by native_decide)
