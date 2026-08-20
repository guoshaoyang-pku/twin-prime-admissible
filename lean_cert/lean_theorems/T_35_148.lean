import Sound
import lean_certs.cert_35_148

open CertVerify

theorem H35_gt_148 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 35) (d := 148) (c := cert_35_148) (by native_decide)
